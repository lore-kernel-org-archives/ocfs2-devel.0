From: Chen, Yukun <yukun.chen@intel.com>
Date: Tue Aug  3 02:25:52 2004
Subject: [Ocfs2-devel] Invalid file rights
Message-ID: <B44D37711ED29844BEA67908EAF36F03768F9E@pdsmsx401.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi All

I find a file rights bug on kernel 2.4 with svn 1313 code. Steps to
duplicate

Being root, create a file in a ocfs2 partition with the sentence below

 open(filename, O_CREAT | O_RDWR )

Then the file will be created with a right 000 --- nobody can write/read
it at 

all. 

But, if I use "touch filename" , the file will be created with a right
of 644.

Any ideas on it? (a bug # 113 has been reported to oss.oracle.com
bugzilla)

Thanx.


Aaron

Intel China Software Lab

Tel:  8621-52574545 Ext.1587

E_mail:yukun.chen@intel.com
