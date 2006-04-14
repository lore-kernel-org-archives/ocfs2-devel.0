From: Michael Steinmann <msl@calivia.com>
Date: Fri, 14 Apr 2006 14:10:20 +0200
Subject: [Ocfs2-devel] using ethernet instead of TCP
In-Reply-To: <443AADE6.30408@oracle.com>
References: <AEC6C66638C05B468B556EA548C1A77DCEBF59@trantor>
	<443AADE6.30408@oracle.com>
Message-ID: <443F912C.3010500@calivia.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Zach Brown wrote:
> James Harper wrote:
>   
>> Has anyone considered having the option of using Ethernet instead of TCP
>> for inter-node communications?
>>     
>
> TIPC might also be interesting.
>
>   http://tipc.sourceforge.net/
>
> - z
>   

TIPC not being IP would solve security issues with the currently
IP-based inter-node connections as well. TIPC is for sure an interesting
option for loosely connected nodes that do not share the same security
realm (where the cluster traffic would have to run over an IP-based
firewall).

--
mike
