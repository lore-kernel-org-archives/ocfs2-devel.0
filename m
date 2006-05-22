From: Paul Taysom <Paul.Taysom@novell.com>
Date: Mon, 22 May 2006 11:01:19 -0600
Subject: [Ocfs2-devel] OCFS2 features RFC
In-Reply-To: <20060517014419.GS21588@ca-server1.us.oracle.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
	<446398D3.7010508@suse.com>
	<20060517014419.GS21588@ca-server1.us.oracle.com>
Message-ID: <447199FF.C8CD.0002.0@novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

 
Two major applications that use byte range locks are Open Office and
Microsoft Office (Word, Excel, ...).  They use them to coordinate
sharing a document when more than one person opens the file.  These
applications typically get a byte range lock on a single byte at a
predetermined offset, then write data into the file about who has the
file open.  This way, when someone else opens the file, they can find
out who else has the file open.  Word is of course going through SAMBA
to access the file system.

Paul Taysom
