From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 11 Jul 2016 13:37:38 -0700
Subject: [Ocfs2-devel] ocfs2/dlm: continue to purge recovery lockres
 when recovery master goes down
In-Reply-To: <20160711133430.fa4e146f61907d2c86b4a208@linux-foundation.org>
References: <57821DB1.9060208@huawei.com>
	<20160711133430.fa4e146f61907d2c86b4a208@linux-foundation.org>
Message-ID: <20160711133738.06b386f800bdfcdcc10e6d52@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, 11 Jul 2016 13:34:30 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 10 Jul 2016 18:04:33 +0800 piaojun <piaojun@huawei.com> wrote:
> 
> > We found a dlm-blocked situation caused by continuous breakdown of
> > recovery masters described below. To solve this problem, we should purge
> > recovery lock once detecting recovery master goes down.
> 
> I'm not sure which kernel version this patch is against, but I get
> significant rejects when merging into 4.7-rc7.  Can you please redo it
> against the latest Linus tree?

Oh, OK, it's probably due to changes in your earlier patches.  It helps
if you use sequence numbering:

[patch 1/3] ocfs2/dlm: disable BUG_ON when DLM_LOCK_RES_DROPPING_REF, is cleared before dlm_deref_lockres_done_handler
[patch 2/3] ocfs2/dlm: solve a BUG when deref failed in dlm_drop_lockres_ref
etc
