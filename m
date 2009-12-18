From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 17 Dec 2009 21:41:10 -0800
Subject: [Ocfs2-devel] [PATCH 0/2] 2 bug fixes for reflink in ocfs2.
In-Reply-To: <4B2AE488.8070602@oracle.com>
References: <4B2AE488.8070602@oracle.com>
Message-ID: <20091218054110.GE20149@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Dec 18, 2009 at 10:10:16AM +0800, Tao Ma wrote:
> 	These are 2 bug fixes for reflink.
> 	Although these 2 are both one line fix, they are important.
> [PATCH 1/2] resolves a bug tristan found serveral months ago. I
> tracked it down recently. It is really race.
> [PATCH 2/2] is found when I tested a corruption in reflink. It
> resolved a bug that the file can't be replayed successfully in
> orphan dir.
> 
> I have run tristan's test cases against these 2 fixes the whole
> week. They should be stable enough to be integrated.

	They are both in the 'fixes' branch of ocfs2.git.

Joel

-- 

"Depend on the rabbit's foot if you will, but remember, it didn't
 help the rabbit."
	- R. E. Shay

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
