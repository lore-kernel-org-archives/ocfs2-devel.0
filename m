From: Jonathan <jdccdevel@gmail.com>
Date: Mon, 15 Jun 2009 15:52:50 -0000
Subject: [Ocfs2-devel] Is Pacemaker integration ready to go?
Message-ID: <4A366E4F.6080507@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I have seen many references online to being able to use OCFS2 with
Pacemaker, but the documentation I have been able to find is very Sparse.

I have kernel 2.6.29, and the latest DLM and Pacemaker (using openais)
and OCFS2-Tools from GIT. (As of June 13).

I was able to build ocfs2_controld.pcmk ... (With some minor changes to
the makefile for my install)

I noticed the OCF version of o2cb is not in the latest git snapshot of
OCFS2-Tools I downloaded. (I found it at
http://oss.oracle.com/pipermail/ocfs2-devel/2008-November/003400.html)

Is the OCF o2cb not there because Pacemaker integration isn't ready yet?

Is there anything else I need or need to know?

Thanks

Jonathan deBoer

-- 

J. deBoer Computer Consulting.
42 Birchmont Dr.
Leduc, AB.
T9E-8S4
cell: 780-717-0669 
