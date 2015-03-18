From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Tue, 17 Mar 2015 20:26:49 -0700
Subject: [Ocfs2-devel] [Ocfs2-users]  size increase
In-Reply-To: <CAHW9mbx73AuENu-CQo++2kxBOR+HMv_GLr-taxbRjFHp6syboQ@mail.gmail.com>
References: <CAHW9mbwxOMu5gP8DHW8e65apFaN_+A_gqOG6wV_kUNjVkF2hLg@mail.gmail.com>
	<55094DE0020000D400003494@relay2.provo.novell.com>
	<5508E7F1.6070504@huawei.com>
	<CAHW9mbx73AuENu-CQo++2kxBOR+HMv_GLr-taxbRjFHp6syboQ@mail.gmail.com>
Message-ID: <CAEeiSHX-U+t+5j218FF58gEujpf4rDJLs4ipr1XbUhPptN0RyA@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This is because you are specifying a 128k cluster size. Refer to man
mkfs.ocfs2 for more.
On Mar 17, 2015 8:04 PM, "Umarzuki Mochlis" <umarzuki@gmail.com> wrote:

> Hi,
>
> What I meant by total size is output of 'du -hs'
>
> I can see output of fdisk on mpath1 of ocfs2 LUN similar to logical
> volume of ext4 partition (255 head & 63 sectors)
>
> It is a 2 nodes ocfs cluster.
>
> 2015-03-18 10:50 GMT+08:00 Xue jiufei <xuejiufei@huawei.com>:
> > Hi Umarzuki,
> > What is the meaning of total size, file size or disk usage?
> > If you means the disk usage, I think maybe the difference of
> > cluster size(the minimum allocation unit) is the case.
> > Have you notice the cluster size or block size of your ocfs2
> > and ext4 filesystem?
> >
> > Thanks,
> > Xuejiufei
> >
>
> _______________________________________________
> Ocfs2-users mailing list
> Ocfs2-users at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-users
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20150317/3ead2592/attachment.html 
