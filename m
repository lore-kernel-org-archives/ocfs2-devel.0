From: Paul Jackson <pj@sgi.com>
Date: Fri Jun 24 15:34:11 2005
Subject: [Ocfs2-devel] Re: [RFC] [PATCH] OCFS2
In-Reply-To: <Xine.LNX.4.44.0506231358230.14123-100000@thoron.boston.redhat.com>
References: <20050518223303.GE1340@ca-server1.us.oracle.com>
	<Xine.LNX.4.44.0506231358230.14123-100000@thoron.boston.redhat.com>
Message-ID: <20050623200524.298a6ab4.pj@sgi.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Morris <jmorris@redhat.com>
Cc: mark.fasheh@oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, torvalds@osdl.org, akpm@osdl.org, wim.coekaerts@oracle.com, lmb@suse.de

James wrote:
> Any chance of splitting it out?

Responding to your post, but I guess it's really Oracle I'm asking:

On my first glance just now at the git-ocfs patch, I was surprised that
what seemed to be separable facilities were combined into one patch.  I
see a file system, a lock manager (is that what DLM stands for - please
spell out acronyms)  and a configuration file system.


+configfs/
+       - directory containing configfs documentation and example code.
  ...
+dlmfs.txt
+       - info on the userspace interface to the OCFS2 DLM.
  ...
+ocfs2.txt
+       - info and mount options for the OCFS2 clustered filesystem.


These combine to make a 45 thousand line patch.  That's a big patch.
Only the netdev and reiser4 patches (and the combined linus.patch)
are bigger.

Shouldn't these be 3 patches, or more?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
