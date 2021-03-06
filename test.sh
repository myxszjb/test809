if [ $(command -v x-ui | grep -c "x-ui") -lt 1 ]
then echo 未安装x-ui，请先安装x-ui，并替换好809专用xray内核，再新建ws8988节点，接着重新运行此脚本
else if [ $(command -v wget | grep -c "wget") -lt 1 -o $(command -v nginx | grep -c "nginx") -lt 1 ]
then yum update || apt update
yes | yum upgrade || yes | apt upgrade
yum update || apt update
yum install wget nginx -y || apt install wget nginx -y
fi
spip=$(curl -s ifconfig.me)
spport="8988"
s=$(echo $(($(cat /usr/local/x-ui/bin/config.json | grep -o "port.*" | grep -n "8988" | cut -c 1)-1)))
id=$(cat /usr/local/x-ui/bin/config.json | grep -o '"id".*' | sed -n "$s"p | cut -d '"' -f4)
fakeid=$(echo $RANDOM | md5sum | cut -c 1-22)
md5="3d99ff138e1f41e931e58617e7d128e2"
spkey=$(echo -n "if5ax/?fakeid=$fakeid&spid=81117&pid=81117&spip=$spip&spport=$spport$md5" | md5sum | cut -d " " -f1)
url=$(curl -s -X GET -H "Host:dir.wo186.tv:809" -H "User-Agent:Mozilla/5.0 (Linux; Android 11; M2012K11AC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.104 Mobile Safari/537.36" "http://dir.wo186.tv:809/if5ax/?fakeid=$fakeid&spid=81117&pid=81117&spip=$spip&spport=$spport&spkey=$spkey" | grep -o "url.*" | cut -d '"' -f3 | sed 's/\\//g')
host=$(echo $url | cut -d "/" -f3 | cut -d ":" -f1)
port=$(echo $host | cut -d ":" -f2)
path=$(echo $url | grep -o "/if5ax.*")
enpath=$(echo $path | sed 's/=/\\u003d/g' | sed 's/&/\\u0026/g')
config=$(echo -n "{\"add\":\"$host\",\"aid\":\"0\",\"host\":\"$host\",\"id\":\"$id\",\"net\":\"ws\",\"path\":\"$enpath\",\"port\":\"809\",\"ps\":\"联通809免流\",\"scy\":\"auto\",\"sni\":\"\",\"tls\":\"\",\"type\":\"\",\"v\":\"2\"}" | base64 -w 0)
echo -n "vmess://$config" | base64 -w 0 > /usr/share/nginx/html/809
[ $(ps -A | grep "nginx" | wc -l) -lt 1 ] && nginx
if [ $(crontab -l | grep "lt809ml/sub" | wc -l) -lt 1 ]
then crontab -l > crontablist
echo "0 0-23/3 * * * bash <(curl -s https://raw.githubusercontent.com/shoujiyanxishe/shjb/main/lt809ml/sub)" >> crontablist
crontab crontablist
rm -rf crontablist
fi
fi
