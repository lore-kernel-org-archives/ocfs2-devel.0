From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Mar 18 16:24:57 2004
Subject: [Ocfs2-devel] Re: [PATCH]remove oin's needs_flush_list
In-Reply-To: <200403181600.i2IG0Xj4027264@penguin.co.intel.com>
References: <200403181600.i2IG0Xj4027264@penguin.co.intel.com>
Message-ID: <20040318222452.GP20057@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 18, 2004 at 08:00:33AM -0800, Rusty Lynch wrote:
> The following is a very simple patch to remove the needs_flush_list
> list_head and in_needs_flush_list boolean members of ocfs_inode.
Excellent, committed.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
