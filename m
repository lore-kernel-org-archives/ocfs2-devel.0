From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Wed Apr 21 19:07:55 2004
Subject: [Ocfs2-devel] Commenting patch
Message-ID: <60C14C611F1DDD4198D53F2F43D8CA3B0E3F7C@orsmsx410.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil Mushran wrote:
> I thought Kurt was already done with mkfs.
> 
> But comments can't hurt... unless it is C++ style. :-)
> Please could you use C style comments... /* */.

Just curious why you don't want C++ style comments.  They are part of
the C standard since 1999 and all the compilers that can compile the
kernel support them.  I noticed that other code in the kernel uses them
too.

I'm just curious since I am a fan of those style comments.

But I'll be happy to redo it in the /* */ style.

John

-- 
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting
Q: What is the most annoying thing on usenet and in e-mail?
