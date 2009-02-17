From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 17 Feb 2009 13:56:04 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Use the right access_* method in
 ctime update of xattr.
In-Reply-To: <20090217054449.GC5489@mail.oracle.com>
References: <1234816768-8571-1-git-send-email-tao.ma@oracle.com>
	<20090217054449.GC5489@mail.oracle.com>
Message-ID: <499A5174.90008@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> On Tue, Feb 17, 2009 at 04:39:28AM +0800, Tao Ma wrote:
>> In ctime updating of xattr, it use the wrong type of access for
>> inode, so use ocfs2_journal_access_di instead.
>>
>> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> 
> 	Eek!  How did tristan's and my testing miss this?  Mark, this is
> a bugfix for .29.
actually tristan's test case found this and I just don't have time to 
investigate on it until now. 
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1065

Thank you, tristan.

Regards,
Tao
