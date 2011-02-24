From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Thu, 24 Feb 2011 10:32:44 -0600
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
Message-ID: <AANLkTi=AeHH665ijW86isXnda78ma_=JOQBMsTZGJ_y_@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,

On Wed, Feb 23, 2011 at 3:44 PM, Joel Becker <jlbec@evilplan.org> wrote:
>
> ? ? ? ?I would love to see you modify tailtest to expose this bug. ?You
> should be able to do it with one set of writes (your write(4k),
> write(32b), write(4K at someplace past 4K+32b)) test). ?It will be a lot
> easier to debug if it is a simple script rather than a bunch of C
> writes.
>

I have posted the patch for ocfs2-test on the test mailing list.

While coding the test, I discovered that the problem does not occur
for sparse,inline-data. I thought it might be because it is the first
test in the series so I changed the order and confirmed that the test
does not fail for sparse,inline-data. Any ideas?

-- 
Goldwyn
