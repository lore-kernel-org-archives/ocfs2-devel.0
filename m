From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:32:48 +0800
Subject: [Ocfs2-devel] [PATCH 00/34] OCFS2: Add trace event and replace
 mlog(0).
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <4D12FB20.7060301@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

forget to say.
you can view from
http://repo.or.cz/w/taoma-kernel.git/shortlog/refs/heads/mlog_replace

and pull from
git://repo.or.cz/taoma-kernel.git mlog_replace

Regards,
Tao

On 12/23/2010 03:19 PM, Tao Ma wrote:
> Hi all,
>
> This patch set is my attempt to replace our old debug(mlog) with new
> trace events.
>
> Wengang Wang has did some work in this field about one year ago.
> http://oss.oracle.com/pipermail/ocfs2-devel/2009-September/005230.html
> But at that time we don't have ocfs2 1.6 introduced, so we delay this
> work until now after ocfs2 1.6 and UEK(Unbreakable Enterprise Kernel)
> are released.
>
> All patches except one(see below) are only mlog related, so they
> shouldn't affect the normal operations in ocfs2 and they should be easy
> for review(patch 1-5 were already sent to the mail list around one month
> ago).
>
> The only one that changes the codes somehow are patch 15, "ocfs2: Little
> refactoring against ocfs2_iget", but it looks straightforward.
>
> Regards,
> Tao
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
