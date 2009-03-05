From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 4 Mar 2009 17:44:45 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: fix check condition of
	max	inline data
In-Reply-To: <49AE1659.5000206@oracle.com>
References: <49ADF2FB.6060503@oracle.com>
	<1236136898-3999-1-git-send-email-tiger.yang@oracle.com>
	<49ADF8E3.8030605@oracle.com> <49AE15FF.30503@oracle.com>
	<49AE1659.5000206@oracle.com>
Message-ID: <20090305014445.GC8700@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 04, 2009 at 01:49:13PM +0800, Tao Ma wrote:
> Tiger Yang wrote:
> > Hi, Tao,
> > 
> > yes. ocfs2_max_inline_data_with_xattr() in read_inline_data() is more 
> > critical, I think ocfs2_max_inline_data() is also safe before.
> > 
> > I deliberately left ocfs2_max_inline_data() because in some case, like 
> > in mknod, di->i_dyn_features have not been set with 
> > OCFS2_INLINE_XATTR_FL or we couldn't get correct di in somewhere.
> yes, I already noticed it. But as I have said in the previous mail, 
> could you please make it more intelligent? in mknod, we know all the 
> cases so we can do it.

	I just looked, and they all have the di (well, it's called fe in
mknod_locked, but it is still there.  the aops.c functions have it on
the write_ctxt).  I agree with Tao, max_inline_data_with_xattr() is
always the correct function.
	Btw, in mknod, it's safe to call.  The INLINE_XATTR_FL will
*not* be set, which is correct with regards to your previous patch (that
makes sure a block is reserved for the xattrs on an inline directory).
	Good catch!

Joel

-- 

"Win95 file and print sharing are for relatively friendly nets."
	- Paul Leach, Microsoft

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
