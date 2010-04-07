From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 7 Apr 2010 16:54:03 -0700
Subject: [Ocfs2-devel] [RFC] ocfs2: Make ocfs2_extend_trans really
 extending.
In-Reply-To: <4BBD1898.1010308@oracle.com>
References: <1269244904-5783-1-git-send-email-tao.ma@oracle.com>
	<20100407215316.GQ11402@wotan.suse.de>
	<4BBD1898.1010308@oracle.com>
Message-ID: <20100407235403.GA4573@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 08, 2010 at 07:43:20AM +0800, Tao Ma wrote:
> I only did tristan's reflink test cases. And since it is only a RFC,
> I haven't put much time on it.
> If you and Joel are both fine with it, I will give it more try,
> especially the stress test case on xattr, since it depends on
> it heavily. And also I will run some fill_verify_hole test which
> will stress our b-tree codes.
> I think these 2 places may be impacted most by this patch.

	Yes, please.  I agree it simplifies the call, and it may be a
performance help (fewer unnecessary commits).

Joel

-- 

"Senator let's be sincere,
 As much as you can."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
