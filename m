From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 4 May 2009 11:25:52 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <49FE4880.3010208@oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090503234518.GB17044@mit.edu> <49FE4880.3010208@oracle.com>
Message-ID: <20090504182552.GF31249@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tao Ma <tao.ma@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, Theodore Tso <tytso@mit.edu>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Mon, May 04, 2009 at 09:44:32AM +0800, Tao Ma wrote:
> Theodore Tso wrote:
>> On Sat, May 02, 2009 at 11:15:01PM -0700, Joel Becker wrote:
>> How should quota handle reflinks?  Since there are separate inodes,
>> the two files could be owned by different user ID's.  Since the data
>> blocks exist only once, I can imagine a number of different ways of
>> handling it:
<snip>
> yeah, agree. So I will pick #3 in my ocfs2 reflink implementation.

	While at first I was all "sure, this makes sense," now I'm
thinking otherwise.  Because reflink() means the file attributes are
unmodified.  So the original owner owns the new file, and thus the quota
charge doesn't matter.  If and when the new file is changed to another
owner, then the normal quota code will adjust the quotas.

Joel

-- 

"If you are ever in doubt as to whether or not to kiss a pretty girl, 
 give her the benefit of the doubt"
                                        -Thomas Carlyle

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
