From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Feb  2 17:59:19 2004
Subject: [Ocfs2-devel] RE: [Ocfs2-users] RE: Playing with OCFS2
In-Reply-To: <50D19C3AC815734C9E19FE4C4F6128A602A56872@orsmsx403.jf.intel.com>
References: <50D19C3AC815734C9E19FE4C4F6128A602A56872@orsmsx403.jf.intel.com >
Message-ID: <20040202235907.GA25263@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Ahh, good catch! I removed those lines of code as that check is not really
needed (it's simple enough to follow). Thanks!
	--Mark

On Mon, Feb 02, 2004 at 03:13:39PM -0800, Villalovos, John L wrote:
> Enclosed please find a patch which fixes the issue I had.
> 
> The root cause is that spin_trylock will always return 1 on a
> Uniprocessor (UP) system.
> 
> It appears the code in this case had an assumption of a SMP system.  The
> spin_trylock appears to be used as a debugging mechanism to make sure
> that a lock had been previously made before the function was called.
> 
> My patch is just to use the #ifdef CONFIG_SMP but I think that this may
> go against the kernel guidelines but I am not sure.
> 
> John


> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
