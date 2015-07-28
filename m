From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 28 Jul 2015 13:51:37 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix shift left overflow
In-Reply-To: <55B5A7E4.6050600@huawei.com>
References: <55B5A7E4.6050600@huawei.com>
Message-ID: <20150728135137.707a604dfd5221c952e300e8@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, 27 Jul 2015 11:39:16 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:

> cluster pos is defined as u32, when calculate corresponding sector it
> should be converted to u64 first, otherwise it may overflow.

What are the runtime effects of this change?

Please always include this info when fixing bugs so that others can
work out which kernel version(s) should be patched.
