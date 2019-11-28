From: piaojun <piaojun@huawei.com>
Date: Thu, 28 Nov 2019 15:33:38 +0800
Subject: [Ocfs2-devel] [QUESTION] deadlock during umount and quota recovery
Message-ID: <5DDF7852.3060403@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jan,

Umount will get hang with quota recovery, as sb->s_umount will be held
in ocfs2_finish_quota_recovery(). This patch series seem to solve this
problem but they have not merged into mainline. So I wonder if they
have been tested enough?

https://oss.oracle.com/pipermail/ocfs2-devel/2018-February/013355.html
https://oss.oracle.com/pipermail/ocfs2-devel/2018-February/013358.html
https://oss.oracle.com/pipermail/ocfs2-devel/2018-February/013354.html
https://oss.oracle.com/pipermail/ocfs2-devel/2018-February/013356.html
https://oss.oracle.com/pipermail/ocfs2-devel/2018-February/013359.html
https://oss.oracle.com/pipermail/ocfs2-devel/2018-February/013360.html
https://oss.oracle.com/pipermail/ocfs2-devel/2018-February/013357.html

Thanks,
Jun
