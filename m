From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Mar 24 13:58:26 2004
Subject: [Ocfs2-devel] Re: [PATCH]Initialize lockres->cache_list
In-Reply-To: <200403222250.i2MMouhY003199@penguin.co.intel.com>
References: <200403222250.i2MMouhY003199@penguin.co.intel.com>
Message-ID: <20040324195819.GE10672@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 22, 2004 at 02:50:56PM -0800, Rusty Lynch wrote:
> The following is a small patch to initialize the cache_list list_head
> while initializing a new lockres.
Alright, committed. I guess this means we can now rely on list_empty if we
ever need to test the contents of cache_list.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
