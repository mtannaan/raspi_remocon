## 立ち上げ

基本的に公式のgetting started guideを参考にした。

https://projects.raspberrypi.org/en/projects/raspberry-pi-setting-up

Guideから読み取りきれなかったポイントをメモっていく。

### SDカードのフォーマットはFATで
64GBのmicroSDXCカードでguideの手順通り進めても起動しなかった。

Guideに記載のSD Card Formatterは大きなサイズのカードをexFATでフォーマットしてしまうが、piはFATのみ対応。

https://www.raspberrypi.org/documentation/installation/noobs.md

MacのディスクユーティリティでFAT32にフォーマットして解決した。

## ヘッドレスインストール
USBがmicro USB端子のみだったので、手持ちのマウス・キーボードが挿せなかった。Micro HDMIの変換は用意できたが、選択や入力なしでSSHログイン可能になるまでを完結させる必要があった。

### OSの自動選択
OSはfull Raspbianが自動でインストールされるように、SDカードの`os`ディレクトリからRaspbian_Full以外のディレクトリをすべて削除した。

https://github.com/raspberrypi/noobs/blob/master/README.md#how-to-automatically-install-an-os

### Wi-FiとSSH
SDカードの直下に、
- wpa_supplicant.confを作成 (Wi-Fiの接続先を指定)
- ファイル名が`ssh`の空ファイルを作成 (SSHを許可するため)

https://blog.u6k.me/2018/12/20/setup-raspberry-pi-3-model-b-plus-headless.html

## VNC
インストールの完了後はSSHでログインできた。
```
ssh pi@raspberrypi.local
```

SSHでログインして、`sudo raspi-config`でパスワードの変更とVNCの有効化を行った。

VNCの解像度がとても低いので、VNCでログイン後、GUIの設定画面（画面左上のメニュー）から解像度を変更した。

## 部品、回路
基本的に下記を参考にした。

https://qiita.com/takjg/items/e6b8af53421be54b62c9

元の回路からの変更点として、(赤外線LED + 27Ω抵抗) を2つ並列に繋いだ。
制御対象の装置によっては指向性が厳しいため。

赤外線受光器からの入力は、配線の都合でGPIO18から9に変更。

## 寸法
- 基板は30mm(microUSBやminiHDMIがでっぱる +2mm) x 65mm (microSDでっぱる +3mm, アンテナでっぱる +2mm)
- 基板間の高さはPi Zero WHの取り付け済みヘッダ + 購入したピンソケット (Useconn FH-2x20SG) を合わせて11mm
- 基板の端からmicroUSBやminiHDMIの端子の端までは7mm

###　ねじ穴
https://www.amazon.co.jp/%E3%82%B5%E3%83%B3%E3%83%8F%E3%83%A4%E3%83%88-Raspberry-Pi%E7%94%A8%E3%82%B9%E3%83%9A%E3%83%BC%E3%82%B5%E3%83%BC-%E9%BB%84%E9%8A%85%E8%A3%BD-MPS-M2611/dp/B01ARIIQEG/ref=pd_ybh_a_11?_encoding=UTF8&psc=1&refRID=24PE2C9C3RAHP4PQW3N2

穴はM2.6

## pigpioの設定
[pigpio](http://abyz.me.uk/rpi/pigpio/)を用いてGPIOの制御を行った。

デーモンを走らせる必要があるので、サービスとして登録した。
```
sudo systemctl enable pigpiod.service
```

いますぐ起動するには、下記。
```
sudo systemctl start pigpiod
```

## hubotのスクリプト
元のQiita記事の作者のスクリプト (hubot-broadlink-rm) は、学習データの永続化をしないようだったので、自前でスクリプトを書いた。

学習や送信のシェルスクリプトは元記事と同様のものを書いて、自作のhubotスクリプトからそれを呼び出す形とした。

## ダイキンエアコンの長い信号
ダイキンエアコンのリモコンの信号長が長く、そのままだと送信できなかった。(chain is too longのエラー)
下記の記事の通りにirrp.pyを編集して、長い信号を圧縮して記録するようにした。

https://korintje.com/blog/2019/02/04/00/24/33/

## 使い方
### 準備
- pidpiodをserviceとして起動しておく
- `cd path/to/this/directory`
- `bin/prepare_gpio.sh`

### 学習
- `bin/pi-learn.sh (signal_name)`

### 学習した信号のリストアップ・削除
- `bin/pi-list.py`
- `bin/pi-remove.py signal_name [signal_name_2 ...]`

### 学習した信号の送信
- `bin/pi-send.sh signal_name`

### チャットボットとして動かす
- Slackにhubotを追加
- トークンをdata/tokenに保存
- IFTTTでgoogle assistantから特定のフレーズをslackに投稿するように設定
- フレーズの内容をもとにpi-send.shを叩くスクリプト (homebot.coffee) を作成
- `bin/run.sh` で実行

### チャットボットをサービス化
sudoで次を実行

- `sudo systemctl link path/to/homebot.service`
- `systemctl enable homebot`
- `systemctl start homebot`

以降、ラズパイの起動時に自動的にbotが立ち上がる
