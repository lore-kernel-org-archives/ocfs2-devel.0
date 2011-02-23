From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Wed, 23 Feb 2011 16:31:25 -0600
Subject: [Ocfs2-devel] [PATCH] Treat writes as new when holes span
 across page boundaries
In-Reply-To: <20110223214444.GM4020@noexit>
References: <AANLkTikByGbpDyDmbM7kNV-ZAt1Ts5BzbM0Ospi=o8Ki@mail.gmail.com>
	<20110222233417.GC28774@noexit>
	<AANLkTik3387QOadM+-7FaXLT90ednn6+=oDfiyzjt=Tv@mail.gmail.com>
	<20110223093932.GA30720@noexit>
	<AANLkTikZHYK3_BTuS_eOApJnT866t4-HPbRc96jpiWYX@mail.gmail.com>
	<20110223191338.GA4020@noexit>
	<AANLkTimrFoVm11T=Hyq+Uf7wfX8n7zSZStNnAs4sPmvK@mail.gmail.com>
	<20110223211704.GH4020@noexit>
	<AANLkTinmrT4JA4T+0uGHqPgFuyOXbhU0uv9pV=a9wC4y@mail.gmail.com>
	<20110223213730.GK4020@noexit> <20110223214444.GM4020@noexit>
Message-ID: <AANLkTi=3YbbK1ugAP_87HL8FJdOZVKpbJnGM5Y5MdK01@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,

On Wed, Feb 23, 2011 at 3:44 PM, Joel Becker <jlbec@evilplan.org> wrote:
> On Wed, Feb 23, 2011 at 01:37:31PM -0800, Joel Becker wrote:
>> On Wed, Feb 23, 2011 at 03:35:36PM -0600, Goldwyn Rodrigues wrote:
>> > On Wed, Feb 23, 2011 at 3:17 PM, Joel Becker <jlbec@evilplan.org> wrote:
>> > >> 2. ?the previous write ended in a page boundary, but not a cluster
>> > >> boundary. eg, clustersize=16K but pos is at the page boundary = 4k
>> > >
>> > > ? ? ? ?Must it be a page boundary? ?What about a block boundary? ;-)
>> >
>> > I am not sure of this, but I would like to stick with page boundary. I
>> > am too poor to afford a machine with a page size bigger than 4k to
>> > test this ;)
>>
>> ? ? ? Create a filesystem with 1K blocks and 16K clusters. ?Now you
>> have four blocks per page, and you can test block vs page boundaries.

Proved, it is page boundary.

>
> ? ? ? ?I would love to see you modify tailtest to expose this bug. ?You
> should be able to do it with one set of writes (your write(4k),
> write(32b), write(4K at someplace past 4K+32b)) test). ?It will be a lot
> easier to debug if it is a simple script rather than a bunch of C
> writes.
>

Here is a simple script. I will incorporate later into tailtest later.

FILENAME=/mnt/f2

for i in `seq 0 256`; do
	let s=$i*4096
	echo "a" | dd of=$FILENAME count=1 bs=1 seek=$s conv=notrunc 2>/dev/null
	let t=$s+4095
	echo "b" | dd of=$FILENAME count=1 bs=1 seek=$t conv=notrunc 2>/dev/null
done


-- 
Goldwyn
