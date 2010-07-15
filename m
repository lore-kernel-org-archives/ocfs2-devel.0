From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 15 Jul 2010 11:04:37 +0800
Subject: [Ocfs2-devel] [PATCH 0/5 v2] Add readahead support in CoW for
	reflinked files.
In-Reply-To: <20100715023156.GB14909@mail.oracle.com>
References: <4C3D6CBA.10401@oracle.com>
	<20100715023156.GB14909@mail.oracle.com>
Message-ID: <4C3E7AC5.3030905@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 07/15/2010 10:31 AM, Joel Becker wrote:
> On Wed, Jul 14, 2010 at 03:52:26PM +0800, Tao Ma wrote:
>> 	When we try to CoW some clusters for a reflinked file, we have to
>> read the contents first, allocate some clusters and then map these
>> pages to the new clusters. Currently, we use block_read_full_page to
>> read it, but it is a little bit slower.
>> 	So this patch set try to add readahead support for CoW. Before we
>> start, we call readahead first so that the pages can be read at the
>> very first. And during CoW, when we find a readahead page, we know
>> that we need to move the readahead window, so a new asyncreadahead
>> is called.
>
> 	I think this looks good.  Can you create a branch in your git
> tree for it?  I'll pull when I build merge-window.
done. please pull from
git://oss.oracle.com/git/tma/linux-2.6.git cow_readahead.

Regards,
Tao
