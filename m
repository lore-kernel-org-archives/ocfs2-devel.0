From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 22 Feb 2013 13:21:40 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix ocfs2_init_security_and_acl()
 to initialize acl correctly
In-Reply-To: <51275362.8020104@oracle.com>
References: <51275362.8020104@oracle.com>
Message-ID: <20130222132140.0e093dfd.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, 22 Feb 2013 19:15:46 +0800
Jeff Liu <jeff.liu@oracle.com> wrote:

> We need to re-initialize the security if it isn't preserved for ocfs2_reflink().
> however, the code logic is broken at ocfs2_init_security_and_acl() although
> ocfs2_init_security_get() succeed, as a result, ocfs2_acl_init() does not involked.

When writing a changelog, please describe the end-user-visible effects
of the bug, so that others can more easily decide which kernel
version(s) should be fixed, and so that downstream kernel maintainers
can more easily work out whether this patch will fix a problem which
they or their customers are observing.
