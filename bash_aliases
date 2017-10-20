alias x='cd ~/xcalar'
alias lsusr='pgrep -u $(whoami) usrnode\|childnode\|xcmgmtd | xargs -r ps -fp'
function b()
{
    echo "build commands are: $@"
    (cd $XLRDIR && time build-clang "$@")
    ret=$?
    return $ret
}
alias bs='b sanitySerial'
alias bcb='b clean && b config && b'
alias topNodes='top -p `pgrep -d ',' "usrnode|childnode|xcmgmtd"` -d 0.5'
alias gdb='gdb -q'
alias murder='killall -9 usrnode xcmgmtd childnode'
alias xchdfs="docker run --rm ravwojdyla/snakebite -n hdfs-sanity"
alias lscore='find . -name "core.*"'
alias v='vim'
alias c='time cmBuild'
function cs()
{
    dir="$(pwd)"
    x
    # R recursive, q inverted index, u unconditional, b build only
    cscope -Rub
    cd "$dir"
}

function gdbNode()
{
    local nodeNum=$1
    local maxLoop=1000
    local sleepTime="1"
    local pid=""
    for ii in `seq 1 $maxLoop`; do
        pid=$(lsusr | grep -- "--nodeId $nodeNum" | awk '{print $2}')
        if [ "$pid" != "" ]; then
            break;
        fi
        echo >&2 "Looking for node $nodeNum..."
        sleep $sleepTime
    done
    if [ "$pid" = "" ]; then
        read -t 1 -N 10000 discard 
        echo >&2 "Didn't find node $nodeNum after $(($maxLoop * $sleepTime))s"
        return 1
    fi
    shift
    sudo -E /usr/bin/gdb -p $pid "usrnode" $@
}

function gdbMgmtd()
{
    pid=$(lsusr | grep "xcmgmtd" | awk '{print $1}')
    sudo -E libtool --mode=execute /usr/bin/gdb -p $pid "$XLRDIR/src/bin/mgmtd/xcmgmtd"
}

function gdbCore()
{
    local coreFile=$1
    gdb usrnode "$coreFile"
}

function gdbCoreCli()
{
    local coreFile=$1
    gdb xccli "$coreFile"
}

function gdbCoreMgmtd()
{
    local coreFile=$1
    gdb xcmgmtd "$coreFile"
}

loop ()
{
    if [ "$*" = "" ]; then
        echo "Usage:\n\tloop <args>\n" 1>&2;
        return 1;
    fi;
    count=1;
    while true; do
        echo "`date`: Running iteration $count: $*" 1>&2;
        "$@";
        if [ "$?" != "0" ]; then
            echo "`date`: $* failed at iteration $count" 1>&2;
            break;
        else
            echo "`date`: $* passed at iteration $count" 1>&2;
        fi;
        count=$(( $count + 1 ));
    done
}

function getLine()
{
    fn=$1
    line=$2
    tail -n+$line $fn | head -n1
}

function runner()
{
    logDir=$(mktemp -d "${TMPDIR:-/tmp/}$(basename 0).XXXXXXXXXXXX")
    logOut="$logDir/stdout"
    logErr="$logDir/stderr"
    startTime=$(date +%s)
    "$@" 1>"$logOut" 2>"$logErr"
    ret=$?
    endTime=$(date +%s)
    duration=$((endTime - startTime))
    if [ "$ret" != "0" ]; then
        echo "Failed $@ with return '$ret' ($duration secs)"
        echo "stdout at $logOut"
        echo "stderr at $logErr"
        exit $ret
    else
        echo "Finished $@ in $duration secs"
        rm -rf "$logDir"
        exit 0
    fi
}

function async()
{
    if [ "$*" = "" ]; then
        echo "Usage:\n\tasync <args>\n" 1>&2;
        return 1;
    fi;

    (runner "$@" &)
}

aws_ec2_bystack () {
    aws ec2 describe-instances --filters 'Name=tag-key,Values=aws:cloudformation:stack-name' "Name=tag-value,Values=$1";
}

aws_format_instances () {
    jq -r '
    .Reservations[].Instances[] |
        [
         "\(if .Tags and ([.Tags[] | select( .Key == "Name" )] != []) then .Tags[] | select( .Key == "Name" ) | .Value else "-" end)",
         .InstanceId,
         .ImageId,
         .EbsOptimized,
         "\(if .SriovNetSupport then .SriovNetSupport else "-" end)",
         "\(if .EnaSupport then .EnaSupport else "-" end)",
         .State.Name,
         .LaunchTime,
         .PrivateIpAddress,
         "\(if .PublicIpAddress then .PublicIpAddress else "None" end)",
         "\(if .PublicDnsName and .PublicDnsName != "" then .PublicDnsName else "None" end)"
        ] |@csv' |  aws_format_output
}

aws_format_output () {
    sed 's/.000Z//g' | sort -rn | column -t
}

s3_cluster_ssh() {
    cluster="$1"
    aws_ec2_bystack $cluster | aws_format_instances | cut -f 11 -d, | tr -d '"' | paste -sd " " - | awk "{print \"cssh \" \$0}"
}

getAzureIps() {
    resourceGroup="$1"
    az vm list-ip-addresses -g "$resourceGroup" | jq "map(.virtualMachine.network.publicIpAddresses[0].ipAddress) | .[]" | sed "s/\"//g" | tr '\n' ' '

}

updatePuppet() {
    sudo /opt/puppetlabs/bin/puppet agent -t -v
}

