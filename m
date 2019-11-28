From: Changwei Ge <chge@linux.alibaba.com>
Date: Thu, 28 Nov 2019 17:05:58 +0800
Subject: [Ocfs2-devel] [QUESTION] deadlock during umount and quota
 recovery
In-Reply-To: <5DDF7852.3060403@huawei.com>
References: <5DDF7852.3060403@huawei.com>
Message-ID: <8ed6847c-26f4-4019-c5b8-77ac7c34d4bb@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jun,

For your information, with this patch(21158ca85b73 ("ocfs2: without 
quota support, avoid calling quota recovery")) applied which was already 
merged into mainline, given that you are not using disk quota, recovery 
hang can be workaound.

IIRC, Jan's patches somehow didn't reach completion and might cause 
side-effect.

Of course, if Jan can finish it, that would be better.

	-Changwei

On 2019/11/28 3:33 ??, piaojun wrote:
> Hi Jan,
> 
> Umount will get hang with quota recovery, as sb->s_umount will be held
> in ocfs2_finish_quota_recovery(). This patch series seem to solve this
> problem but they have not merged into mainline. So I wonder if they
> have been tested enough?
> 
> https://oss.oracle.com/pipermail/ocfs2-devel/2018-February/013355.html
> https://oss.oracle.com/pipermail/ocfs2-devel/2018-February/013358.html
> https://oss.oracle.com/pipermail/ocfs2-devel/2018-February/013354.html
> https://oss.oracle.com/pipermail/ocfs2-devel/2018-February/013356.html
> https://oss.oracle.com/pipermail/ocfs2-devel/2018-February/013359.html
> https://oss.oracle.com/pipermail/ocfs2-devel/2018-February/013360.html
> https://oss.oracle.com/pipermail/ocfs2-devel/2018-February/013357.html
> 
> Thanks,
> Jun
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
