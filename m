From: Lynch, Rusty <rusty.lynch@intel.com>
Date: Thu Apr 29 14:11:32 2004
Subject: [Ocfs2-devel] 
	FW: [Bug 66] New: Undefined function for kernels > 2.6.5
Message-ID: <032EB457B9DBC540BFB1B7B519C78B0E0411BEE9@orsmsx404.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

FYI: I submitted a new bug about a change in the 2.6.6 kernel that
breaks ocfs.

    --rusty

-----Original Message-----
From: bugzilla-daemon@oss.oracle.com
[mailto:bugzilla-daemon@oss.oracle.com] 
Sent: Thursday, April 29, 2004 11:48 AM
To: Lynch, Rusty
Subject: [Bug 66] New: Undefined function for kernels > 2.6.5

http://oss.oracle.com/bugzilla/show_bug.cgi?id=66

           Summary: Undefined function for kernels > 2.6.5
           Product: OCFS v2 (WIP)
           Version: unspecified
          Platform: PC
        OS/Version: other
            Status: NEW
          Severity: normal
          Priority: P2
         Component: other
        AssignedTo: kurt.hackel@oracle.com
        ReportedBy: rusty.lynch@intel.com


A change has made its way into kernels past 2.6.5 that removes the
blk_run_queues() function that is being used in
hash.c:wait_on_buffer_modified()

This results in load_ocfs2 failing due to an undefined symbol.



------- You are receiving this mail because: -------
You reported the bug, or are watching the reporter.
