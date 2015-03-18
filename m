From: Umarzuki Mochlis <umarzuki@gmail.com>
Date: Wed, 18 Mar 2015 11:03:32 +0800
Subject: [Ocfs2-devel] [Ocfs2-users] size increase
In-Reply-To: <5508E7F1.6070504@huawei.com>
References: <CAHW9mbwxOMu5gP8DHW8e65apFaN_+A_gqOG6wV_kUNjVkF2hLg@mail.gmail.com>
	<55094DE0020000D400003494@relay2.provo.novell.com>
	<5508E7F1.6070504@huawei.com>
Message-ID: <CAHW9mbx73AuENu-CQo++2kxBOR+HMv_GLr-taxbRjFHp6syboQ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

What I meant by total size is output of 'du -hs'

I can see output of fdisk on mpath1 of ocfs2 LUN similar to logical
volume of ext4 partition (255 head & 63 sectors)

It is a 2 nodes ocfs cluster.

2015-03-18 10:50 GMT+08:00 Xue jiufei <xuejiufei@huawei.com>:
> Hi Umarzuki,
> What is the meaning of total size, file size or disk usage?
> If you means the disk usage, I think maybe the difference of
> cluster size(the minimum allocation unit) is the case.
> Have you notice the cluster size or block size of your ocfs2
> and ext4 filesystem?
>
> Thanks,
> Xuejiufei
>
