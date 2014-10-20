From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 20 Oct 2014 16:12:19 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Fix d_splice_alias() return
 code checking
In-Reply-To: <1413715184-30196-2-git-send-email-richard@nod.at>
References: <1413715184-30196-1-git-send-email-richard@nod.at>
	<1413715184-30196-2-git-send-email-richard@nod.at>
Message-ID: <20141020161219.e68870b37a4a45dbf1e89db8@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Richard Weinberger <richard@nod.at>
Cc: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>

On Sun, 19 Oct 2014 12:39:44 +0200 Richard Weinberger <richard@nod.at> wrote:

> d_splice_alias() can return a valid dentry, NULL or an ERR_PTR.
> Currently the code checks not for ERR_PTR and my oops in
> ocfs2_dentry_attach_lock().

It's unclear what the second sentence is trying to tell us.  The patch
fixes an oops?  If so, a copy of the trace would be useful, as would an
explanation of why it occurred.  If not, I'm all confused.
