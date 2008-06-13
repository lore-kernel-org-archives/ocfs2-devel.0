From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 12 Jun 2008 19:56:22 -0700
Subject: [Ocfs2-devel] [PATCH 6/8] Add extent tree operation for xattr
	value.v1
In-Reply-To: <4851D1E8.7020609@oracle.com>
References: <484792D1.3080802@oracle.com>
	<20080605073437.GA19797@tma-pc2.cn.oracle.com>
	<20080612234412.GR28100@wotan.suse.de>
	<4851D1E8.7020609@oracle.com>
Message-ID: <20080613025622.GV28100@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 13, 2008 at 09:48:24AM +0800, Tao Ma wrote:
> >Hmm, at this point, wouldn't it make sense to have a couple high-level
> >"ocfs2_foo_insert_extent" functions whcih build up anm ocfs2_extent_tree 
> >and
> >then pass it down to the common ocfs2_insert_extent?
> Why do we need that? Just to reduce the parameter to one 
> "ocfs2_extent_tree *"? ;) Any other benefit?

No, that's mostly what I was concerned with. Well, that and type-checking -
we don't have to have a void * in ocfs2_insert_extent any more.
	--Mark

--
Mark Fasheh
