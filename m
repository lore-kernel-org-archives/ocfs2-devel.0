From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 14 Feb 2011 14:02:31 -0800
Subject: [Ocfs2-devel] [PATCH] Zero from EOF instead of next block
In-Reply-To: <20110214220021.GB8413@noexit>
References: <AANLkTik_4d7Ey5LCcV7pQMXEeZ_GcN-gC6cK-oX7f+B9@mail.gmail.com>
	<20110214072503.GA8413@noexit>
	<AANLkTikTP7wtSGsoUSw1pVT6aWDrjSYFrn_A+8Aam9HD@mail.gmail.com>
	<20110214220021.GB8413@noexit>
Message-ID: <20110214220231.GC8413@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 14, 2011 at 02:00:22PM -0800, Joel Becker wrote:
> 	I'm going to check out your test case, but please explain what
> you think is broken.

	Argh, it's C code.  I don't have time today.  Please see my
testcase in ocfs2-test:

http://oss.oracle.com/git/?p=ocfs2-test.git;a=commit;h=271a35defdd7101fba300343f5784b3255cb7b64

Let me know what I did wrong ;-)

Joel

-- 

"The nice thing about egotists is that they don't talk about other
 people."
         - Lucille S. Harper

			http://www.jlbec.org/
			jlbec at evilplan.org
