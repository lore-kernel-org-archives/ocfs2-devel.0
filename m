From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 23 Jan 2008 22:05:54 -0000
Subject: [Ocfs2-devel] [PATCH 08/30] ocfs2: Readpages support
In-Reply-To: <1200609356-17788-9-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
	<1200609356-17788-9-git-send-email-mark.fasheh@oracle.com>
Message-ID: <20080123140541.473cf034.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

> On Thu, 17 Jan 2008 14:35:34 -0800 Mark Fasheh <mark.fasheh@oracle.com> wrote:
> Add ->readpages support to Ocfs2. This is rather trivial - all it required
> is a small update to ocfs2_get_block (for mapping full extents via b_size)
> and an ocfs2_readpages() function which partially mirrors ocfs2_readpage().
> 

Was there any performance improvement?

> + * siutations are safe to ignore.

Cnat tpye.
