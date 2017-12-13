#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    
    const char *input = "8789382321573427567542547165869751253948652973"
    "493212365865746629944298942598285368427811992521691827434494352311"
    "944363682185994633915444617454729229165624148542754499834428283444"
    "638936182824252426433228229168579352421416361878599196268857915722"
    "682724427119883677628657413414672747181492551736868392658741841769"
    "855619964542531657841929294536783269377285717812121553465924328742"
    "447418161663286939585299383675756696632283355664352734843314528831"
    "759819556793353272319954522311189363931925833382225959825228334685"
    "332622248746374496246443184187486179494179392289882933919414577226"
    "419364174562438941826681971742557864459945674775827156923362492432"
    "547116535298713361298257352496674252385739523399229482142188724178"
    "585251996421945884485435654748472729842326374666646952171763582837"
    "887818431716368412156758517789846193775756964473668448542895342152"
    "869597276884197319766313238338922474381498299758561617551228576437"
    "319459133355562888171129939116949726676569142389992918319971634125"
    "489776494912272194777961241349585278432138247926851176966315121412"
    "414964518457586552761865977247484329962764985279112925311852921499"
    "481397243458415847823522149216348587346711184954241434372829792433"
    "478312582858512595791334331823874446563866798315849333979151327854"
    "116866884477316967764596219248216671127517898849878839918458185132"
    "499947675435261694637669757914647565269115873997647365579594649233"
    "538969213429448218339914571252563295644896313522687224576285145641"
    "282314873821116829768868381924129969329243733375242621353992566586"
    "384185152398767328665967318887795325732437131282384192349631955899"
    "875394672215175352723848995243862672689594848813799447963922554198"
    "387431647142754634593517412965864652136898537438565185834518496615"
    "928448792641967618674812587783936235848845352462397941789813876323"
    "112381153621785768991214254281146961586529762773922242262682423325"
    "895467574776833982642949294425921319493982618845484279514721288413"
    "283768192419551534234525315384134925772623483695813999256476246238"
    "682994684368596671524639749494363595899311362362479295548996791397"
    "461625541838552787135742442118542278299694431514789864133334291447"
    "966644237548182561728628128776886755141422652399925297762628443291"
    "88218189254491238956497568";
    
    size_t size = strlen(input);
    
    size_t sum = 0;
    
    for(int i = 0; i < size; ++i) {
        if(input[i] == input[(i+1) % size]) {
            sum += input[i] - 48;
        }
    }
        
    printf("sum = %lu\n", sum);
    
    return 0;
}
