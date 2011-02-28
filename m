From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Mon, 28 Feb 2011 13:07:21 -0600
Subject: [Ocfs2-devel] [PATCH] Treat writes as new when holes span
 across page boundaries
In-Reply-To: <20110228180301.GA13071@noexit>
References: <AANLkTik3387QOadM+-7FaXLT90ednn6+=oDfiyzjt=Tv@mail.gmail.com>
	<20110223093932.GA30720@noexit>
	<AANLkTikZHYK3_BTuS_eOApJnT866t4-HPbRc96jpiWYX@mail.gmail.com>
	<20110223191338.GA4020@noexit>
	<AANLkTimrFoVm11T=Hyq+Uf7wfX8n7zSZStNnAs4sPmvK@mail.gmail.com>
	<20110223211704.GH4020@noexit>
	<AANLkTinmrT4JA4T+0uGHqPgFuyOXbhU0uv9pV=a9wC4y@mail.gmail.com>
	<20110223213730.GK4020@noexit> <20110223214444.GM4020@noexit>
	<AANLkTi=3YbbK1ugAP_87HL8FJdOZVKpbJnGM5Y5MdK01@mail.gmail.com>
	<20110228180301.GA13071@noexit>
Message-ID: <AANLkTimkrDuT4LDe=RH8_VzzOAVacAcEdTz0+Ss3g0yJ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,

On Mon, Feb 28, 2011 at 12:03 PM, Joel Becker <jlbec@evilplan.org> wrote:
> On Wed, Feb 23, 2011 at 04:31:25PM -0600, Goldwyn Rodrigues wrote:
>> Here is a simple script. I will incorporate later into tailtest later.
>>
>> FILENAME=/mnt/f2
>>
>> for i in `seq 0 256`; do
>> ? ? ? let s=$i*4096
>> ? ? ? echo "a" | dd of=$FILENAME count=1 bs=1 seek=$s conv=notrunc 2>/dev/null
>> ? ? ? let t=$s+4095
>> ? ? ? echo "b" | dd of=$FILENAME count=1 bs=1 seek=$t conv=notrunc 2>/dev/null
>> done
>
> ? ? ? ?You shouldn't need to do 256 runs. ?I would like to see directed
> tests that just hit one spot in a file and expose the corruption. ?For
> example, your described problem case should work like so:
>
> ?# Write the first three blocks of the file, getting us past inline_data
> ?dd if=/dev/urandom of=$FILENAME count=3 bs=4096
> ?# Write a byte in the next page
> ?dd if=/dev/urandom of=$FILENAME count=1 bs=1 seek=12228 conv=notrunc
> ?# Write after some partial-block portion, trying to expose failed zeroing
> ?dd if=/dev/urandom of=$FILENAME count=4084 bs=1 seek=12300 conv=notrunc
>
> I would expect this to expose the problem as you've described for
> clustersize >= 8K.
>


Yes, that will work as well, as long as you can differentiate between
the random characters from urandom and the (unexpected) non-zero
characters in the (userspace) holes. You can read the data from
[12229-12299] in the file you have created and check for zeros.

If you don't want too many changes - s/256/3/ in the script I posted
and check for the 4th block.

But yes, you are on the right path of re-creating the issue.


-- 
Goldwyn
