From: Lynch, Rusty <rusty.lynch@intel.com>
Date: Wed Mar 17 18:20:38 2004
Subject: [Ocfs2-devel] Is oin->needs_flush_list just dead code??
Message-ID: <032EB457B9DBC540BFB1B7B519C78B0E0385367E@orsmsx404.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs_release_cached_oin(), there is some logic that will empty
oin->needs_flush_list and set oin->ins_needs_flush_list to false, but
there is no code that actually adds entries to this list.  Is this just
dead code?

 

    --rusty

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040317/4ff9a7e4/attachment.htm
