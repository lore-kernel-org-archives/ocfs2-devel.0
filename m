From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Fri Jul 30 18:12:28 2004
Subject: [Ocfs2-devel] fail to write to a file in a way of direct
	io(kernel 2.4.24) 
Message-ID: <3ACA40606221794F80A5670F0AF15F840508F7AA@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: ocfs2-devel@oss.oracle.com

How about 2.6 kernel?


________________________________

	From: ocfs2-devel-bounces@oss.oracle.com [mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Chen, Yukun
	Sent: 2004��7��30�� 7:16
	To: ocfs2-devel@oss.oracle.com
	Subject: [Ocfs2-devel] fail to write to a file in a way of direct io(kernel 2.4.24) 
	
	

	Hi All,

	 

	I meet a bug on kernel 2.4.24, rev 1303, steps to duplicate: (also, I have committed a bug #110 in the bugzilla of oss.oracle.com)

	 

	1.open a file in an ocfs2 partition in a way of direct io(read/write rights have been granted to the file)

	 

	2.write something to the file

	 

	nothing will be found on the file even after I umounted and then remounted the partition. Furthermore, I can write to the file successfully in a non-directio way.

	 

	Any ideas on it? 

	 

	Thanx.  

	 

	Aaron

	Intel China Software Lab

	Tel:  8621-52574545 Ext.1587

	E_mail:yukun.chen@intel.com

	 

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040731/ea6e3c06/attachment.htm
