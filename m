From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Wed Apr 21 19:49:17 2004
Subject: [Ocfs2-devel] Commenting patch
In-Reply-To: <60C14C611F1DDD4198D53F2F43D8CA3B0E3F7C@orsmsx410.jf.intel.com>
References: <60C14C611F1DDD4198D53F2F43D8CA3B0E3F7C@orsmsx410.jf.intel.com>
Message-ID: <40871688.3060408@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We typically use c++ style comments to comment
individual lines of code and c-style for actual comments.

Atleast in the module (v1) we have stuck to this coding style,
alongwith tabs (no spaces), etc. from linus' style.

But tools, expecially debugocfs, is another story.... thanks
to an unnamed rebel. ;-)

Villalovos, John L wrote:

>Sunil Mushran wrote:
>  
>
>>I thought Kurt was already done with mkfs.
>>
>>But comments can't hurt... unless it is C++ style. :-)
>>Please could you use C style comments... /* */.
>>    
>>
>
>Just curious why you don't want C++ style comments.  They are part of
>the C standard since 1999 and all the compilers that can compile the
>kernel support them.  I noticed that other code in the kernel uses them
>too.
>
>I'm just curious since I am a fan of those style comments.
>
>But I'll be happy to redo it in the /* */ style.
>
>John
>
>  
>
