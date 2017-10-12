From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 12 Oct 2017 14:53:55 +0800
Subject: [Ocfs2-devel] A o2cb DLM problem
In-Reply-To: <59DF7E35020000F9000921C2@prv-mh.provo.novell.com>
References: <59DF7E35020000F9000921C2@prv-mh.provo.novell.com>
Message-ID: <6ffa4f8b-bd5f-f831-b9d7-9c53269705bd@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10/12/2017 02:37 PM, Gang He wrote:
> Hello list,
> 
> We got a o2cb DLM problem from the customer, which is using o2cb stack for OCFS2 file system on SLES12SP1(3.12.49-11-default).
> The problem description is as below,
> 
> Customer has three node oracle rack cluster
> gal7gblr2084
> gal7gblr2085
> gal7gblr2086
> 
> On each node they have configured two ocfs resources as a filesystem. The two node gal7gblr2085 and gal7gblr2086 got hung and went into loop to kill each other and they want root cause analysis.
> Anyway, all I see in logs is those messages flooding /var/log/messages
> 
> 2017-10-05T06:50:25.980773+01:00 gal7gblr2085 kernel: [16874541.314199] o2net: Connection to node gal7gblr2086 (num 2) at 10.233.217.12:7777 has been idle for 30.5 secs, shutting it down.
Looks it is an old kernel. Shutting down connection when idle timeout
will cause losing dlm message which may cause hung. Please apply the
following 3 patches.

8c7b638cece1 ocfs2: quorum: add a log for node not fenced
8e9801dfe37c ocfs2: o2net: set tcp user timeout to max value
c43c363def04 ocfs2: o2net: don't shutdown connection when idle timeout

Thanks,
Junxiao.
> 2017-10-05T06:50:37.456786+01:00 gal7gblr2085 kernel: [16874552.778726] o2net: No longer connected to node gal7gblr2086 (num 2) at 10.233.217.12:7777
> 2017-10-05T06:50:45.176798+01:00 gal7gblr2085 kernel: [16874560.487834] (kworker/u64:1,13245,10):dlm_send_remote_convert_request:392 ERROR: Error -107 when sending message 504 (key 0x4a68dd81) to node 2
> 2017-10-05T06:50:45.176812+01:00 gal7gblr2085 kernel: [16874560.487838] o2dlm: Waiting on the death of node 2 in domain 18AE08328428452BA610E7BDE26F5246
> 2017-10-05T06:50:50.284796+01:00 gal7gblr2085 kernel: [16874565.589996] (kworker/u64:1,13245,10):dlm_send_remote_convert_request:392 ERROR: Error -107 when sending message 504 (key 0x4a68dd81) to node 2
> 2017-10-05T06:50:50.284811+01:00 gal7gblr2085 kernel: [16874565.590000] o2dlm: Waiting on the death of node 2 in domain 18AE08328428452BA610E7BDE26F5246
> 2017-10-05T06:50:55.400808+01:00 gal7gblr2085 kernel: [16874570.700448] (kworker/u64:1,13245,10):dlm_send_remote_convert_request:392 ERROR: Error -107 when sending message 504 (key 0x4a68dd81) to node 2
> 2017-10-05T06:50:55.400824+01:00 gal7gblr2085 kernel: [16874570.700452] o2dlm: Waiting on the death of node 2 in domain 18AE08328428452BA610E7BDE26F5246
> 2017-10-05T06:51:00.512766+01:00 gal7gblr2085 kernel: [16874575.808944] (kworker/u64:1,13245,26):dlm_send_remote_convert_request:392 ERROR: Error -107 when sending message 504 (key 0x4a68dd81) to node 2
> 2017-10-05T06:51:00.512783+01:00 gal7gblr2085 kernel: [16874575.808948] o2dlm: Waiting on the death of node 2 in domain 18AE08328428452BA610E7BDE26F5246
> 2017-10-05T06:51:02.456785+01:00 gal7gblr2085 kernel: [16874577.749286] (ora_diag_rcp2,24339,0):dlm_do_master_request:1344 ERROR: link to 2 went down!
> 2017-10-05T06:51:02.456797+01:00 gal7gblr2085 kernel: [16874577.749289] (ora_diag_rcp2,24339,0):dlm_get_lock_resource:929 ERROR: status = -107
> 2017-10-05T06:51:05.632955+01:00 gal7gblr2085 kernel: [16874580.920124] (kworker/u64:1,13245,26):dlm_send_remote_convert_request:392 ERROR: Error -107 when sending message 504 (key 0x4a68dd81) to node 2
> 2017-10-05T06:51:05.632973+01:00 gal7gblr2085 kernel: [16874580.920132] o2dlm: Waiting on the death of node 2 in domain 18AE08328428452BA610E7BDE26F5246
> 2017-10-05T06:51:07.976787+01:00 gal7gblr2085 kernel: [16874583.262561] o2net: No connection established with node 2 after 30.0 seconds, giving up.
> 2017-10-05T10:03:38.439542+01:00 gal7gblr2084 kernel: [1911889.097543] (mdb_psp0_-mgmtd,21126,0):dlm_send_remote_unlock_request:358 ERROR: Error -107 when sending message 506 (key 0x4a68dd81) to node 1
> 2017-10-05T10:03:38.439543+01:00 gal7gblr2084 kernel: [1911889.097547] (mdb_psp0_-mgmtd,21126,0):dlm_send_remote_unlock_request:358 ERROR: Error -107 when sending message 506 (key 0x4a68dd81) to node 1
> 
> 
> Did you guys encounter such problem when using o2cb stack? since we mainly focus on pmck stack, but I still want to help this customer to know the root cause.
> 
> 
> Thanks
> Gang
> 
> 
> 
> 
> 
> 
