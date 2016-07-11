From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 11 Jul 2016 13:34:30 -0700
Subject: [Ocfs2-devel] ocfs2/dlm: continue to purge recovery lockres
 when recovery master goes down
In-Reply-To: <57821DB1.9060208@huawei.com>
References: <57821DB1.9060208@huawei.com>
Message-ID: <20160711133430.fa4e146f61907d2c86b4a208@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, 10 Jul 2016 18:04:33 +0800 piaojun <piaojun@huawei.com> wrote:

> We found a dlm-blocked situation caused by continuous breakdown of
> recovery masters described below. To solve this problem, we should purge
> recovery lock once detecting recovery master goes down.

I'm not sure which kernel version this patch is against, but I get
significant rejects when merging into 4.7-rc7.  Can you please redo it
against the latest Linus tree?

Thanks.
