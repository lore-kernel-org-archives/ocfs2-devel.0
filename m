From: Umarzuki Mochlis <umarzuki@gmail.com>
Date: Wed, 18 Mar 2015 10:50:24 +0800
Subject: [Ocfs2-devel] [Ocfs2-users] size increase
In-Reply-To: <55094DE0020000D400003494@relay2.provo.novell.com>
References: <CAHW9mbwxOMu5gP8DHW8e65apFaN_+A_gqOG6wV_kUNjVkF2hLg@mail.gmail.com>
	<55094DE0020000D400003494@relay2.provo.novell.com>
Message-ID: <CAHW9mbxD7DhZt=eed50WJ4UNSHkRXjxdAXHG_8COsFCQUJWJMQ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

1) yes

even 36K text html file in ext4 became 128K inside ocfs2

2) I installed ocfs-tools on Ubuntu 14.04 amd64

A LUN added to a newly created LVM group, so no other physical volume
added other than this one and formatted as ocfs2 with below command

sudo mkfs.ocfs2 -b 4K -C 128K -L "Web Cluster" /dev/webvg/weblv

/dev/webvg/weblv mounted on /var/www

I'll check with ext3 later

2015-03-18 10:05 GMT+08:00 Zhen Ren <zren@suse.com>:
> Hi Umarzuki,
> 1) Does it always occur, or sometime?
>
> 2) Could you give more info to reproduce this issue?
>
> 3) And could you have a try on ext3? Frankly,most of suse people (if I don't make a mistake) use ext3.
>
> Also,I add the devel mail list. Hope experts there can help.
>
> --
> Best regards,
> Eric, Ren
> HA team, SUSE
>
