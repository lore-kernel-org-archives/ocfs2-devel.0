From: Daniel Phillips <phillips@istop.com>
Date: Thu May 19 01:52:34 2005
Subject: [Ocfs2-devel] Re: [RFC] [PATCH] OCFS2
In-Reply-To: <20050518223303.GE1340@ca-server1.us.oracle.com>
References: <20050518223303.GE1340@ca-server1.us.oracle.com>
Message-ID: <200505190230.23624.phillips@istop.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, torvalds@osdl.org, akpm@osdl.org, wim.coekaerts@oracle.com, lmb@suse.de

On Wednesday 18 May 2005 18:33, Mark Fasheh wrote:
> http://oss.oracle.com/projects/ocfs2/dist/files/patches/2.6.12-rc4/broken-o
>ut/06_dlm.patch A distributed lock manager built with the cluster file
> system use case in mind. The OCFS2 dlm exposes a VMS style API, though
> things have been simplified internally. The only lock levels implemented
> currently are NLMODE, PRMODE and EXMODE.

+ if (recovery && 
+     (!dlm_is_recovery_lock(name, strlen(name)) || convert) ) {
+  goto error;
+ }

Zero terminated strings for lock names is bad taste.  It generates a bunch of 
useless strlen executions and you force an ascii namespace for no apparent 
reason.  Add a 9th parameter, namelen, to the lock call maybe?

Regards,

Daniel 
