From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Apr 30 12:45:05 2004
Subject: [Ocfs2-devel] Two questions
In-Reply-To: <60C14C611F1DDD4198D53F2F43D8CA3B88C608@orsmsx410.jf.intel.com>
References: <60C14C611F1DDD4198D53F2F43D8CA3B88C608@orsmsx410.jf.intel.com>
Message-ID: <20040430174459.GF9043@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Apr 30, 2004 at 10:29:48AM -0700, Villalovos, John L wrote:
> In ocfs2/src/hash.c:
> 
> HASHBUCKET:  This is a linked list which does not use the kernel's
> linked list code.  Is there a reason for this?
Legacy. It'll actually be gone soon as the only thing using it is the
lockres hash, which will soon be merged into the inode hash.

> BARF_BARF_BARF: Is there a reason for that being there?  If so maybe it
> should be documented.
I'll let Kurt explain that one :)

We sometimes put #warnings and whatnot in the code for things we want to
revisit in the future...
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
