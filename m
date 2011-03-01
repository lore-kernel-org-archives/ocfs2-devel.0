From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Mon, 28 Feb 2011 20:11:24 -0600
Subject: [Ocfs2-devel] [PATCH] Treat writes as new when holes span
 across page boundaries
In-Reply-To: <20110228194021.GC16768@noexit>
References: <AANLkTikZHYK3_BTuS_eOApJnT866t4-HPbRc96jpiWYX@mail.gmail.com>
	<20110223191338.GA4020@noexit>
	<AANLkTimrFoVm11T=Hyq+Uf7wfX8n7zSZStNnAs4sPmvK@mail.gmail.com>
	<20110223211704.GH4020@noexit>
	<AANLkTinmrT4JA4T+0uGHqPgFuyOXbhU0uv9pV=a9wC4y@mail.gmail.com>
	<20110223213730.GK4020@noexit> <20110223214444.GM4020@noexit>
	<AANLkTi=3YbbK1ugAP_87HL8FJdOZVKpbJnGM5Y5MdK01@mail.gmail.com>
	<20110228180301.GA13071@noexit>
	<AANLkTimkrDuT4LDe=RH8_VzzOAVacAcEdTz0+Ss3g0yJ@mail.gmail.com>
	<20110228194021.GC16768@noexit>
Message-ID: <AANLkTinh_5+r6UMDd7hCsqFkpYhe7TwG8sV=jON4JbhV@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 28, 2011 at 1:40 PM, Joel Becker <jlbec@evilplan.org> wrote:
> On Mon, Feb 28, 2011 at 01:07:21PM -0600, Goldwyn Rodrigues wrote:
>> On Mon, Feb 28, 2011 at 12:03 PM, Joel Becker <jlbec@evilplan.org> wrote:
>> > On Wed, Feb 23, 2011 at 04:31:25PM -0600, Goldwyn Rodrigues wrote:
>> >> Here is a simple script. I will incorporate later into tailtest later.
>> >>

>>
>> Yes, that will work as well, as long as you can differentiate between
>> the random characters from urandom and the (unexpected) non-zero
>> characters in the (userspace) holes. You can read the data from
>> [12229-12299] in the file you have created and check for zeros.
>
> ? ? ? ?You're right about the urandom being bad for this. ?Maybe it
> should be zeros. ?But still.
>

I used /usr/bin/yes instead. The patch is on the ocfs2-test-devel ML.


-- 
Goldwyn
