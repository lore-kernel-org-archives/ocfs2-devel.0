From: Kurt Hackel <Kurt.Hackel@oracle.com>
Date: Wed, 8 Mar 2006 07:56:29 -0800
Subject: [Ocfs2-devel] 2.6.16-rc5-mm3: Why did
	dlm_lockres_master_requery() become global?
In-Reply-To: <20060308113052.GF4006@stusta.de>
References: <20060307021929.754329c9.akpm@osdl.org>
	<20060308113052.GF4006@stusta.de>
Message-ID: <20060308155629.GC29232@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 08, 2006 at 12:30:52PM +0100, Adrian Bunk wrote:
> On Tue, Mar 07, 2006 at 02:19:29AM -0800, Andrew Morton wrote:
> >...
> > Changes since 2.6.16-rc3-mm2:
> >...
> >  git-ocfs2.patch
> >...
> >  git trees
> >...
> 
> Why did dlm_lockres_master_requery() become global?
> 
> It is neither used in another file nor does any of the changeset 
> descriptions escribe it.

True.  I intended to use it in a recent fix, but ended up using another
function and failed to back out the change to make it global.  I'll
clean this up as soon as possible.

Thanks
-kurt
