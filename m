From: Wim Coekaerts <wim.coekaerts@oracle.com>
Date: Tue Feb  3 19:01:00 2004
Subject: [Ocfs2-devel] Re: [Ocfs2-users] invalidate: busy buffer
In-Reply-To: <50D19C3AC815734C9E19FE4C4F6128A6178029@orsmsx403.jf.intel.com>
References: <50D19C3AC815734C9E19FE4C4F6128A6178029@orsmsx403.jf.intel.com>
Message-ID: <20040204010041.GC5821@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

yeah and I don't think this is resolved yet.

Manish, how often do you sync oss/svn with cvs ocfs2 ?Since we have so
many updates coming in pretty much daily we should make sure we update
often enough.

On Tue, Feb 03, 2004 at 04:38:44PM -0800, Villalovos, John L wrote:
> Playing with revision 19 from Subversion of OCFS2.
> 
> It appears that when I create and then delete directories I will get the
> following error message when I unmount the partition:
> 
> invalidate: busy buffer
> ...
> invalidate: busy buffer
> 
> 
> Has anyone else seen this?
> 
> John
> _______________________________________________
> Ocfs2-users mailing list
> Ocfs2-users@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-users
