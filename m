From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Fri Apr 30 12:29:55 2004
Subject: [Ocfs2-devel] Two questions
Message-ID: <60C14C611F1DDD4198D53F2F43D8CA3B88C608@orsmsx410.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2/src/hash.c:

HASHBUCKET:  This is a linked list which does not use the kernel's
linked list code.  Is there a reason for this?

BARF_BARF_BARF: Is there a reason for that being there?  If so maybe it
should be documented.

Thanks,
John

-- 
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting
Q: What is the most annoying thing on usenet and in e-mail?
