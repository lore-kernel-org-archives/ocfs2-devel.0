From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Aug  6 20:34:14 2004
Subject: [Ocfs2-devel] why skip zero is removed?
In-Reply-To: <3ACA40606221794F80A5670F0AF15F8405167C12@pdsmsx403>
References: <3ACA40606221794F80A5670F0AF15F8405167C12@pdsmsx403>
Message-ID: <20040807013357.GY8008@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Aug 07, 2004 at 09:27:18AM +0800, Ling, Xiaofeng wrote:
> So the drop is not caused by zeros. But now I can not reproduce it after
> the 
> machine is rebooted. The performance now is high again. A strange
> problem.
Can you update from the latest svn, revision r1332 contains a fix which
*seem*s to increase my overall performance quite a bit, but I'm not
completely convinced yet (as in, I want others to tell me whether it helps).
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
