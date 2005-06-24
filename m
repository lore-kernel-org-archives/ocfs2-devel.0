From: Paul Jackson <pj@sgi.com>
Date: Fri Jun 24 15:34:11 2005
Subject: [Ocfs2-devel] Re: [RFC] [PATCH] OCFS2
In-Reply-To: <20050623200524.298a6ab4.pj@sgi.com>
References: <20050518223303.GE1340@ca-server1.us.oracle.com>
	<Xine.LNX.4.44.0506231358230.14123-100000@thoron.boston.redhat.com>
	<20050623200524.298a6ab4.pj@sgi.com>
Message-ID: <20050623202906.39c8ec8a.pj@sgi.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Jackson <pj@sgi.com>
Cc: jmorris@redhat.com, mark.fasheh@oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, torvalds@osdl.org, akpm@osdl.org, wim.coekaerts@oracle.com, lmb@suse.de

A couple more random questions:

 1) How does this lock manager relate to the Red Hat lock manager,
    the dlm-* patches?

    Note as an aside that dlm-* has 23 patches for a total of 14
    thousand lines, or about 600 lines per patch.  This is rather
    different than burying a lock manager into a 45 thousand line
    new file system patch ;)

 2) Would a diffstat be a useful addition to this patch?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
