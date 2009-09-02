From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 2 Sep 2009 01:37:12 -0700
Subject: [Ocfs2-devel] [PATCH 10/14] ocfs2: Allocation in
 ocfs2_xa_prepare_entry() values in ocfs2_xa_store_value()
In-Reply-To: <4A9DFBBF.1010102@oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
	<1251448563-12508-11-git-send-email-joel.becker@oracle.com>
	<4A9CE168.6050107@oracle.com>
	<20090901202111.GH3826@mail.oracle.com>
	<20090902015158.GA9165@mail.oracle.com>
	<4A9DFBBF.1010102@oracle.com>
Message-ID: <20090902083711.GB10257@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Sep 02, 2009 at 12:59:43PM +0800, Tao Ma wrote:
> OK, I think I have finished reviewing the whole patch set. Thanks
> for the work. You can add my ACK to this set now. And once it get
> merged into merge-window, I can ask tristan to run it with his xattr
> test case.

	All of the changes are in xa_loc.  Can you have tristan against
that first?  I don't want to push this into merge_window without at
least a quick pass to make sure there isn't a disasterous idea in there
:-)

Joel

-- 

"Gone to plant a weeping willow
 On the bank's green edge it will roll, roll, roll.
 Sing a lulaby beside the waters.
 Lovers come and go, the river roll, roll, rolls."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
