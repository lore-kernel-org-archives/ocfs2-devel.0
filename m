From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 5 Feb 2015 08:43:47 +0800
Subject: [Ocfs2-devel] ocfs2 patch review for 3.19
In-Reply-To: <20150204160024.3bfdfa2ecc067c1760f5fdd2@linux-foundation.org>
References: <20150204160024.3bfdfa2ecc067c1760f5fdd2@linux-foundation.org>
Message-ID: <54D2BCC3.8070109@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Andrew,

On 2015/2/5 8:00, Andrew Morton wrote:
> 
> Thsi time I have only four patches which I consider need expert review,
> please.
> 
> ocfs2-prune-the-dcache-before-deleting-the-dentry-of-directory.patch
> 
> o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
> (Joseph Qi had issues)
Srini has already explained the difference with the old version.
I have no issue with this patch now:)

Joseph
> 
> ocfs2-call-ocfs2_journal_access_di-before-ocfs2_journal_dirty-in-ocfs2_write_end_nolock.patch
> (Mark has list of things which need doing)
> 
> ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
> (Mark has issues with it)
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> 
