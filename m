From: Boaz Harrosh <bharrosh@panasas.com>
Date: Sun, 01 Feb 2009 16:26:12 -0000
Subject: [Ocfs2-devel] [xfs-masters] [PATCH] fs: Add new pre-allocation
 ioctls to vfs for compatibility with legacy xfs ioctls
In-Reply-To: <4985C1B0.8060905@sandeen.net>
References: <4980C71F.1010804@ankitjain.org>
	<200901310138.34164.arnd@arndb.de>	<20090130171423.f99c88d0.akpm@linux-foundation.org>	<200901310248.42820.arnd@arndb.de>
	<49856FE6.8020601@panasas.com>	<Pine.LNX.4.64.0902011104320.20875@anakin>	<49857BEB.30404@panasas.com>	<Pine.LNX.4.64.0902011151180.20875@anakin>
	<4985966D.8040402@panasas.com> <4985C1B0.8060905@sandeen.net>
Message-ID: <4985CCFA.4070008@panasas.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>, mfasheh@suse.com, joel.becker@oracle.com, linux-kernel@vger.kernel.org, hch@infradead.org, xfs-masters@oss.sgi.com, viro@zeniv.linux.org.uk, Ankit Jain <me@ankitjain.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

Eric Sandeen wrote:
> Boaz Harrosh wrote:
> 
> ...
> 
>> I don't understand
>>
>> if you have a structure like
>> struct foo {
>> 	u32 one;
>> 	u32 two;
>> };
>> vs
>> struct foo_packed {
>> 	u32 one;
>> 	u32 two;
>> } __packed;
>>
>> Just adding an __attribute__((packed)) to it clearly does not change
>> the layout of the structure. Are you saying the __attribute__((packed))
>> is an hint to the compiler that foo_packed might be used unaligned. This
>> is just brain-dead, because I can use an unaligned pointer to foo just as
>> I can to foo_packed. Otherwise there is no difference what-so-ever between
>> the two. I have to see it to believe. It is totally the wrong hint in the
>> wrong place taking away valuable meaning of saying "please don't use padding
>> holes in this structure"
>>
>> Sorry for been so slow, I just don't get it.
>> Boaz
> 
> While I'm no gcc guru, I can confirm that gratuitous use of the packed
> attribute is suboptimal; adding "packed" to every ondisk structure made
> obdump -d xfs.ko | wc -l explode by about 15,000 lines on ia64.

Yes! but are the structures the same? that is sizeof(foo_packed) == sizeof(foo) ?
If not then clearly above is expected.

In anyway, if __attribute__((packed)) makes some brain-dead gcc do the wrong thing
putting a _Padding member where you expect an alignment hole, and a BUILD_BUG_ON(sizeof() != ())
statement somewhere in code is a must, specifically for the brain-dead.

> 
> -Eric

There are to many places in Kernel where these things are left to chance that give
me an headache, not talking about cross platform mounts.

Boaz
