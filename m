Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2C37C6FA99
	for <ocfs2-devel@archiver.kernel.org>; Fri, 10 Mar 2023 03:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=RF5NMT+BhC/BYsbWckeW+3/LjXoPhh68/+khv6hvVHs=;
 b=cXMjA1jeDtu9Ju/+tbx+G4sKpJOEiG02kj/uC65RJcU6RmOFAKQ1AwDZH8OdiAZMCzOpKQ5/Hc8l
   wB+3QJkFgfaCaTcwHawGMcQqeZm++cCRWeoyFDmwayU5r3NB+rn1zI2e3epDMWmx4tA9teQeTddO
   GWKUoH//KpOp52EMgz5aDSQBVDSecNAsXe3nE1aix3WyzCt494hfqGSzQRdGTyMHIfowdGb5C7CF
   OrOVEOvhZbu0PAuxdjS0Tkt2KCyfCM66Ah/ovuTsAdY6hPk1gSNGgvzSgMeJWz4e1CWEtUvTxEif
   x2h0mbd1qMzEczUkdW4ckkaBtOLhJsoBjeOxrw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=RF5NMT+BhC/BYsbWckeW+3/LjXoPhh68/+khv6hvVHs=;
 b=NXzPFm5rvNeGJmNimkKCnZjJEgutroJYos8MVgTfjG3AndjaXd4x6Uay8Tw38pin8u7PzjozmsWU
   5OcW70Ek8nSWDkAdIhRD7msrqYxewlsgDiBSSP7aSSgSrahOmGsS57g/L3fmCAaP4pmI1H0iCGO/
   2XxO1pMTpTpqh9g6TtiMmSa0PZ0iAN9QowGy3TJB5Xj0+fYBW9MUWmi1DFbpnzh34blBq/SyEIq9
   CcxC0uOxs3Mc5kYgu+O0uvBMD0HKx+zI/cfi+UhJGz6VCkPMhGv3LproqjwEM0+wxMc58goipQB2
   08VawGBXZcoN1Rhvjdym58cB69HjItp0ltcjvw==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRA008NMDA6DT50@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 10 Mar 2023 03:49:18 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=g6V4Gxmi7X46KWy9Z1dTCBI/CizDod1edUe5jdg4m7c=; b=weIxlQrFrH7JIGKKgO7T578Uqr
 /B8fR68jTGhqMsVGfpT/BaxWruuQhBjZNIMB9XMxB0sW8UP62PBmwYpssTyZKzpULDbKJzjWrXwTj
 I99A/OB0VxIVkDAOP8a/oSy7dpjnKIz8A9uOOqKBIT/YNj5MES4V7s8ac+XfXwc0/X8cTUNeEtMtR
 +qVhEcd7dIzgYWUKwYXTPXqbNBRffvUn3c6iIspER2+Ua/yg5eMsqtDwjDTvBNR+x8U+OcnYtjOKa
 Bdl98syii3w2Cdn2FWAjs7JBZeL1guzZpNrBHxdr3Wk0zCA2+SU5WxYm3HXJgg0Bwjl0sKLKbqWMM
 BPPgR+rA==;
Date: Fri, 10 Mar 2023 03:49:00 +0000
To: Christoph Hellwig <hch@lst.de>
Message-id: <20230310034900.GL3390869@ZenIV>
References: <20230307143125.27778-1-hch@lst.de>
 <20230307143125.27778-3-hch@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230307143125.27778-3-hch@lst.de>
X-Source-IP: 62.89.141.173
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10644
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=216 mlxscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 clxscore=156 spamscore=0
 mlxlogscore=684 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100028
Cc: Evgeniy Dushistov <dushistov@mail.ru>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 2/3] ocfs2: don't use write_one_page in
 ocfs2_duplicate_clusters_by_page
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Al Viro via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Al Viro <viro@zeniv.linux.org.uk>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: zeniv.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: xRxi4qnth5K4WrFPk21qjeStmisKn-Q4
X-Proofpoint-GUID: xRxi4qnth5K4WrFPk21qjeStmisKn-Q4
Reporting-Meta:
 AAFTuN6V5BwGzjj8Jb5NZsLA3N1mD2tu53K6pkiqYdfaFFkhAmEyZ+8FYNLZrhzn
 /9a/1c74IaGRLnj8lyair9l6A1g3ce7z0WN4/QIW9Be5hlWO/5A9E5pZSPWdvzws
 iLL+TLdaVXOPordH2+tUjPHphvGqpSmuAGOtBvPCfJEdi8KrX9atOOHt+6X1taY0
 gL8oNWCB/7WKVsazemk+9bPla1Bh2YPqh/3nVu+OSCTHC6gnX57jw7gLZibOfOIE
 IlJ7nCnLgRnn/YVBbvhIQmAtJZsLnbfHiWIxkUqM0lV4qAT8XPhyrg+w4JZM9Iml
 fVEpkB+v0G0ydSeS4nr1mpcPDQkHZoaAdbqAcCQFSFqnllx+c+YzK/fQL7FzPEby
 LGsGbNQp4KTHQ30n2bflN6dbi0wYOODDvM0HXlBlk6ocqGNsdq0cSYUZsiBCatlI
 uH1H9H4bU/fjrVMuncO1XwQVYl/zPVHVHbG3/68yFo8jQp7J+czyUSjosNRn+woI
 JYKQ4Q9MFKW6bH4UARTh1vlT1GAi8fHWSaiLEDQo8jazgw==

On Tue, Mar 07, 2023 at 03:31:24PM +0100, Christoph Hellwig wrote:
> Use filemap_write_and_wait_range to write back the range of the dirty
> page instead of write_one_page in preparation of removing write_one_page
> and eventually ->writepage.

That one is in vfs.git #work.misc (sorry, missed -next last cycle).

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
