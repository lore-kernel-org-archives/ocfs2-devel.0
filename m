From: Tim Gardner <tim.gardner@canonical.com>
Date: Wed, 13 Feb 2013 20:01:35 -0000
Subject: [Ocfs2-devel] [PATCH 1/2 linux-next] ocfs2: remove kfree()
	redundant null checks
In-Reply-To: <1360784676-74994-1-git-send-email-tim.gardner@canonical.com>
References: <1360784676-74994-1-git-send-email-tim.gardner@canonical.com>
Message-ID: <511BF11C.6070100@canonical.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

On 02/13/2013 12:44 PM, Tim Gardner wrote:
> fs/ocfs2/alloc.c:6138 ocfs2_begin_truncate_log_recovery() info:
>  redundant null check on *tl_copy calling kfree()

Ignore this series. I'll resend.

rtg
-- 
Tim Gardner tim.gardner at canonical.com
