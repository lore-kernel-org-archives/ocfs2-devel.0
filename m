From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 30 Nov 2009 01:36:42 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Implement new OCFS2_IOC_INFO
 ioctl for ocfs2.
In-Reply-To: <87tywf4szb.fsf@basil.nowhere.org>
References: <1259310276-7782-1-git-send-email-tristan.ye@oracle.com>
	<1259310276-7782-2-git-send-email-tristan.ye@oracle.com>
	<87tywf4szb.fsf@basil.nowhere.org>
Message-ID: <20091130093641.GA5456@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Nov 27, 2009 at 09:23:36PM +0100, Andi Kleen wrote:
> It's unclear why you just can't use separate ioctls for each request.

	Because we're going to be adding many info requests, with more
over time.  Much nicer to pass in a list of requests than have a hundred
or more ioctls.  Plus we can do fun versioning.

Joel

-- 

"Sometimes I think the surest sign intelligent
 life exists elsewhere in the universe is that
 none of it has tried to contact us."
                                -Calvin & Hobbes

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
